import pyfoursquare as foursquare

# == OAuth2 Authentication ==
#
# This mode of authentication is the required one for Foursquare

# The client id and client secret can be found on your application's Details
# page located at https://foursquare.com/oauth/
client_id = "PS3QO2SYQYJDDPVIFNXDGTUIROKVIZDTW2II531O3SSIBT42"
client_secret = "OU0SFCWM2V1T4HMTPENOXOMBVHXFXTSCOHMSEDR0RSSU2DVL"
callback = 'http://www.psibi.in'

auth = foursquare.OAuthHandler(client_id, client_secret, callback)

#First Redirect the user who wish to authenticate to.
#It will be create the authorization url for your app
auth_url = auth.get_authorization_url()
print 'Please authorize: ' + auth_url

#If the user accepts, it will be redirected back
#to your registered REDIRECT_URI.
#It will give you a code as
#https://YOUR_REGISTERED_REDIRECT_URI/?code=CODE
code = raw_input('The code: ').strip()

#Now your server will make a request for
#the access token. You can save this
#for future access for your app for this user
access_token = auth.get_access_token(code)
print 'Your access token is ' + access_token
