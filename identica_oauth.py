#!/usr/bin/python
#
# A python script that generates valid OAuth tokens for identi.ca
#
#
import oauth2 as oauth
import urlparse 
 
consumer_key           = "xxxxxxxxxxxxx"
consumer_secret        = "xxxxxxxxxxxxx"
consumer = oauth.Consumer(consumer_key, consumer_secret)
client = oauth.Client(consumer)
request_token_url      = 'https://identi.ca/api/oauth/request_token?oauth_callback=oob'
resp, content = client.request(request_token_url, "POST")
print content
if resp['status'] != '200':
    raise Exception("Invalid response %s." % resp['status'])
 
request_token = dict(urlparse.parse_qsl(content))

print "Request Token:"
print "    - oauth_token        = %s" % request_token['oauth_token']
print "    - oauth_token_secret = %s" % request_token['oauth_token_secret']
print 
authorize_url =      'https://identi.ca/api/oauth/authorize'
print "Go to the following link in your browser:"
print "%s?oauth_token=%s" % (authorize_url, request_token['oauth_token'])
print 

accepted = 'n'
while accepted.lower() == 'n':
    accepted = raw_input('Have you authorized me? (y/n) ')
oauth_verifier = raw_input('What is the PIN? ')

access_token_url = 'https://identi.ca/api/oauth/access_token'
token = oauth.Token(request_token['oauth_token'], request_token['oauth_token_secret'])
token.set_verifier(oauth_verifier)
client = oauth.Client(consumer, token)
 
resp, content = client.request(access_token_url, "POST")
access_token = dict(urlparse.parse_qsl(content))
 
print "Access Token:"
print "    - oauth_token        = %s" % access_token['oauth_token']
print "    - oauth_token_secret = %s" % access_token['oauth_token_secret']
print
print "You may now access protected resources using the access tokens above."
print
