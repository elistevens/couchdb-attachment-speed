#!/bin/bash

curl -s -X DELETE http://localhost:5984/speed
curl -s -X PUT http://localhost:5984/speed
python -c "import couchdb.tools.load; couchdb.tools.load.load_db(file('data/speed.db', 'r'), 'http://localhost:5984/speed')"
echo "n	raw	base64	multi	py b64 encode	py b64 decode"
echo -n "1	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_1/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e1.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e1.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_1 -H "Content-Type: multipart/form-data; boundary="==a2eb84642cd6482486f1c743ea07a598=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e1.multipart
echo "0.000024	0.000017"
echo -n "2	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_2/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e2.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e2.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_2 -H "Content-Type: multipart/form-data; boundary="==d357776aa0774361bfbb2e8695cf0ae7=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e2.multipart
echo "0.000006	0.000006"
echo -n "3	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_3/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e3.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e3.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_3 -H "Content-Type: multipart/form-data; boundary="==bb918a74a7c848baa97a26f4f3650c88=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e3.multipart
echo "0.000010	0.000013"
echo -n "4	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_4/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e4.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e4.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_4 -H "Content-Type: multipart/form-data; boundary="==0ee7c50b2c0a49e3a4e1fc16ee4d2d79=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e4.multipart
echo "0.000053	0.000094"
echo -n "5	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_5/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e5.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e5.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_5 -H "Content-Type: multipart/form-data; boundary="==7571a8cf5e514286a3f61ca5c2661e01=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e5.multipart
echo "0.000287	0.000665"
echo -n "6	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_6/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e6.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e6.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_6 -H "Content-Type: multipart/form-data; boundary="==2f4c6ef0b9d345efa70632d762446e90=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e6.multipart
echo "0.003797	0.005383"
echo -n "7	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_7/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e7.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e7.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_7 -H "Content-Type: multipart/form-data; boundary="==c93381b1e1eb4cae9827fc91c600305b=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e7.multipart
echo "0.040626	0.061827"
echo -n "8	"
curl -s -w '%{time_total}	' -o /dev/null -X PUT 'http://localhost:5984/speed/raw_doc_8/data_raw?rev=1-967a00dff5e02add41819138abb3284d' -H "Content-Type: application/octet-stream" -d @data/10e8.raw
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/ -H "Content-Type: application/json" -d @data/10e8.base64_json
curl -s -w '%{time_total}	' -o /dev/null -X POST http://localhost:5984/speed/multipart_doc_8 -H "Content-Type: multipart/form-data; boundary="==d1def643747747868db3acacc4895490=="" -H "Referer: http://localhost:5984/speed" --data-binary @data/10e8.multipart
echo "0.526701	0.660009"
