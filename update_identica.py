#!/usr/bin/python

#Note: Use your version of PyPump. Upstream seems to be broken and
#i'm too lazy to figure out the new API for sending public tweets using
#PyPump. Patches welcome!

from pypump import PyPump
import sys
import tweepy

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

consumer_key =u''
consumer_secret = u''
oauth_token = ''
oauth_secret = ''

pump = PyPump("psibi@identi.ca", key=consumer_key, secret=consumer_secret, token=oauth_token, token_secret=oauth_secret)
note = pump.Note(status_text)
a = pump.Address()
note.set_to(a.createPublic())
note.send()


# == OAuth Authentication ==
#
# This mode of authentication is the new preferred way
# of authenticating with Twitter.

# The consumer keys can be found on your application's Details
# page located at https://dev.twitter.com/apps (under "OAuth settings")
consumer_key=""
consumer_secret=""

# The access tokens can be found on your applications's Details
# page located at https://dev.twitter.com/apps (located 
# under "Your access token")
access_token=""
access_token_secret=""

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

# If the authentication was successful, you should
# see the name of the account print out
print api.me().name

# If the application settings are set for "Read and Write" then
# this line should tweet out the message to your account's 
# timeline. The "Read and Write" setting is on https://dev.twitter.com/apps
api.update_status(status_text)
