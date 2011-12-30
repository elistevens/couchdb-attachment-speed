# logging
import logging
log = logging.getLogger(__name__)

# stdlib
import base64
import cStringIO
import csv
import datetime
import json
import os
import sys

# 3rd party packages
import couchdb
import couchdb.multipart
import couchdb.tools.dump

# in-house

class Timer(object):
    def __init__(self):
        self.tick_dict = {}
        self.name_list = []
        self.current = datetime.datetime.now()

    def tick(self, name):
        self.tick_dict[name] = datetime.datetime.now() - self.current
        print "Tick:", name
        self.name_list.append(name)
        self.current = datetime.datetime.now()


class App(object):
    def main(self, sys_argv=None):
        field_list = ['e', 'urandom', 'base64_encode', 'base64_decode']
        csv_writer = csv.DictWriter(file(os.path.join('data', 'creation_times.csv'), 'w'), field_list, dialect='excel-tab')
        csv_writer.writeheader()

        bash_file = file('do-curls.sh', 'w')
        print >>bash_file, '#!/bin/bash'
        print >>bash_file, ''
        print >>bash_file, 'curl -s -X DELETE http://localhost:5984/speed'
        print >>bash_file, 'curl -s -X PUT http://localhost:5984/speed'
        print >>bash_file, '''python -c "import couchdb.tools.load; couchdb.tools.load.load_db(file('data/speed.db', 'r'), 'http://localhost:5984/speed')"'''
        print >>bash_file, 'echo "n\traw\tbase64\tmulti\tpy b64 encode\tpy b64 decode"'

        server = couchdb.Server('http://localhost:5984/')
        if 'speed' in server:
            del server['speed']
        db = server.create('speed')

        for e in range(1,9):
            print '10e{}'.format(e)
            n = 10**e

            t = Timer()
            if e > 6:
                data_raw = os.urandom(10**6) * (10**(e-6))
            else:
                data_raw = os.urandom(n)
            #data_raw = 'X' * n
            t.tick('urandom')
            data_base64 = base64.b64encode(data_raw)
            t.tick('base64_encode')
            base64.b64decode(data_base64)
            t.tick('base64_decode')

            file(os.path.join('data', '10e{}.raw'.format(e)), 'w').write(data_raw)
            t.tick('urandom_write')

            file(os.path.join('data', '10e{}.base64'.format(e)), 'w').write(data_base64)
            t.tick('base64_write')

            #data_base64_json = json.dumps({'_id': 'base64_doc_{}'.format(e), "_attachments": {"data_base64": {"content_type": "application/octet-stream", "data": data_base64}}})
            data_base64_json = json.dumps({'_id': 'base64_doc_{}'.format(e), "_attachments": {"data_base64": {"content_type": "application/octet-stream", "data": 'SPLIT'}}})
            json_list = data_base64_json.split('SPLIT')
            t.tick('base64_json_encode')

            with file(os.path.join('data', '10e{}.base64_json'.format(e)), 'w') as data_file:
                data_file.write(json_list[0])
                data_file.write(data_base64)
                data_file.write(json_list[1])
            t.tick('base64_json_write')

            del data_base64

            raw_id, raw_rev = db.save({'_id': 'raw_doc_{}'.format(e)})
            multipart_id, multipart_rev = db.save({'_id': 'multipart_doc_{}'.format(e)})
            doc = db[multipart_id]
            fileobj = cStringIO.StringIO()

            with couchdb.multipart.MultipartWriter(fileobj, headers={'Referer': db.resource.url}, subtype='form-data') as mpw:
                mime_headers = {'Content-Disposition': '''form-data; name="_doc"'''}
                mpw.add('application/json', couchdb.json.encode(doc), mime_headers)

                mime_headers = {'Content-Disposition': '''form-data; name="_attachments"; filename="{}"'''.format('data_raw')}
                mpw.add('application/octet-stream', data_raw, mime_headers)

            header_str, _, _, body = fileobj.getvalue().split('\r\n', 3)
            http_headers = {'Referer': db.resource.url, 'Content-Type': header_str[len('Content-Type: '):]}
            multipart_str = ' '.join(['-H "{}: {}"'.format(k, v) for k, v in http_headers.items()])

            t.tick('multipart')

            file(os.path.join('data', '10e{}.multipart'.format(e)), 'w').write(body)
            t.tick('multipart_write')
            del body

            row_dict = {k:v for k,v in t.tick_dict.items() if k in field_list}
            row_dict['e'] = e

            csv_writer.writerow(row_dict)

            curl_str = '''(time curl -s {}) 2>&1 | fgrep real | sed -e 's/real//g' | tr '\\n' ' ' '''
            curl_str = '''curl -s -w '%{{time_total}}\t' -o /dev/null {}'''


            print >>bash_file, '''echo -n "{}\t"'''.format(e)
            #print >>bash_file, '''echo -n {}.raw'''.format(e)
            print >>bash_file, curl_str.format('''-X PUT 'http://localhost:5984/speed/{}/{}?rev={}' -H "Content-Type: application/octet-stream" -d @data/10e{}.raw'''.format(raw_id, 'data_raw', raw_rev, e))

            #print >>bash_file, '''echo -n 10e{}.base64'''.format(e)
            print >>bash_file, curl_str.format('''-X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e{}.base64_json'''.format(e))

            #print >>bash_file, '''echo -n 10e{}.multipart'''.format(e)
            print >>bash_file, curl_str.format('''-X POST http://localhost:5984/speed/{} {} --data-binary @data/10e{}.multipart'''.format(multipart_id, multipart_str, e))

            print >>bash_file, '''echo "{:.6f}\t{:.6f}"'''.format(t.tick_dict['base64_encode'].total_seconds(), t.tick_dict['base64_decode'].total_seconds())

        couchdb.tools.dump.dump_db('http://localhost:5984/speed', output=file(os.path.join('data', 'speed.db'), 'w'))


if __name__ == "__main__":
    sys.exit(App().main() or 0)

# eof
