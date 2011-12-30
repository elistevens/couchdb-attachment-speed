The intent is to run 'python makedata.py' once, and then repeatedly run 'bash do-curls.sh' to get timing information while making performance tweaks.  Changing the 'for e in range(1,10):' line to range(1,9) will make things run quite a bit faster, if that's an issue (similar can be accomplished by hand-editing the do-curls.sh script and commenting out the last 5 lines).

Here's what I'm doing in makedata.py:

- Creating raw data from /dev/urandom in powers of 10 increments from 10e1 to 10e9, and saving it to disk.
- base64 encoding the raw data in python using the built-in base64 module, and saving that to disk.
- Writing a doc with the _attachments dict filled with the base64 data to disk.
- Populating a DB with some empty docs to be targeted by the raw attachment and multipart APIs.
- Dumping that DB out for reuse.
- Writing a bash script (do-curls.sh) that contains curl commands, etc. to wipe the speed DB, repopulate it with default data, and actually perform the attachment uploads with timing.

All of the python code was written against python 2.7; I'm not sure if it works under 2.6 or lower.  The couchdb-python package is required ('pip install CouchDB').  Pull requests that remove this dependency will be considered, but I have little interest in doing that work myself.

At some point I'd like to investigate multiple attachments and see if that changes anything, but I haven't started that yet.  Pull requests also accepted for this.  :)
