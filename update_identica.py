#!/usr/bin/python

from identi import Identica
import sys

status_text = ""
if (len(sys.argv) > 1):
    for i in range(len(sys.argv)-1):
        status_text = status_text + sys.argv[i+1]
        status_text = status_text + " "
        if len(status_text) > 140:
            print """Sorry, Exceeded 140 Characters. Tweet Again with Limited thoughts."""
            sys.exit(1)
else:
    print """Usage: tw "Enter your status here\""""
    sys.exit(1)

consumer_key ="xxxxxxxxxxxx"
consumer_secret ="xxxxxxxxx"
oauth_token = "xxxxxxxxxxxxx"
oauth_secret = "xxxxxxxxxxx"
identica = Identica(consumer_key,consumer_secret,oauth_token,oauth_secret)
identica.updateStatus(status=status_text)
