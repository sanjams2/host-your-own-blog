#!/usr/bin/env python3

import sys

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

if __name__ == '__main__':
	if len(sys.argv) == 1:
	    print("%s input-file:type ..." % (sys.argv[0]))
	    sys.exit(1)

	combined_message = MIMEMultipart()
	for i in sys.argv[1:]:
	    (filename, format_type) = i.split(":", 1)
	    with open(filename) as fh:
	        contents = fh.read()
	    sub_message = MIMEText(contents, format_type, "us-ascii")
	    sub_message.add_header('Content-Disposition', 'attachment; filename="%s"' % (filename))
	    combined_message.attach(sub_message)

	print(combined_message.as_string())