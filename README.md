# INFlickrSearchPicSwift
Search Photo using Flickr API, and Using Swift

API Notes

The Flickr API is a powerful way to interact with Flickr accounts. With the API, you can read almost all the data associated with pictures and sets. You can also upload pictures through the API and change/add picture information. Luckily this all pretty easy. In this post, I’ll broadly explain how to use the Flickr API so you can get started in any programming language. 

Getting a Flickr API key
The first thing you need is an API key. The API key is a way for Yahoo! to track the activity associated with each API key. It is essentially your user-name for the Flickr API. You can get an API key fairly easily depending on the type of project you are doing. If you’re producing a commercial product, then Yahoo! will want to know about it. You’ll need a special API key for that type of project and Yahoo! will have to approve your product. However, if you’re just experimenting and producing a non-commercial product, you can get an API key instantly. Login or create an account and then go to the Flickr API key request. Note: API keys are necessary for most methods of the Flickr API.


How it works


The first step to working with the Flickr API is having a broad understanding of how it works. There are essentially three steps to working with the API. First, you need to send Flickr a request of the information you would like. 
This is done by building a special URL (more on this later). Second, once Flickr understands your correctly built URL, it will send the information that you requested. The last step is to do something with the data with which Flickr responded. Whatever you’re doing with the Flickr API, your interaction will follow these three steps.


Using the API methods
To send a request to Flickr, use the API methods to build a URL telling Flickr exactly what it is you want. All of the URLs start off with:
http://api.flickr.com/services/rest/?


They then continue based on what data you are requesting. Open the Flickr API Documentation in a separate tab. In the right column of the documentation you’ll see the API Methods column. You can only use one method per request, so for example, let’s say you want to pull data on the latest 200 photos from your Flickr account. To do this you’ll use the ‘people’ method, specifically  ‘flickr.people.getPublicPhotos’. Now you have another piece of your URL. So, it should now look something like this:

http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos


Go ahead and click on that method to get information on what arguments to include. You’ll see that there are two required arguments: api_key & user_id. Next, add the api_key argument the same way you did the method: http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=[your api key here]. The last required argument for this method is user_id. You can easily access your user id as well as lots of other useful information if you are on the flickr.people.GetPublicPhotos API page (or any other method’s page). Scroll to the bottom of the page and click API Explorer: flickr.people.getPublicPhotos. This page will allow you to easily submit a test call to Flickr using that method. In the column on the right you should find your user id. Go ahead and attach this to the end of the URL that you’ve build so far and give it a try:
http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=[your api key here]&user_id=[your user id here]


Retrieving data in JSON format
To receive data in JSON, all you need to do is add the ‘format’ argument to the URL and give it a value of ‘json’:

http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=[your api key here]&user_id=[your user id here]&format=json



Specifying the Number of Results
Back on the flickr.people.getPublicPhotos method page you may have noticed an argument named per_page. You can use this argument to tell Flickr how many results you would like per request. Flickr notes that the default is 100 and the maximum is 500. As with the other arguments, just add it to the URL with the value you want:
http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=[your api key here]&user_id=[your user id here]&format=json&per_page=500


Working with the data
Now that you have a bunch of data from Flickr, you’ll probably want to do something with it. Let’s use it to find the URL to one of the photos in the XML response. To do this, you first need to figure out the URL structure for photos in Flickr. I did a search on Flickr and found this photo:
http://www.flickr.com/photos/cobalt/157623061/. 


Notice the URL structure. The first segment (www.flickr.com) is the domain you are accessing, the second (photos) is what you are accessing, the third (cobalt) is presumably a user-name of the owner of the photo (although you may not know this if you’ve never worked with Flickr) and finally, the fourth (157623061) appears to be an ID number. Based on that URL, you may be able to guess that only two of those segments change depending on the picture (the third segment–the owner and the fourth–the ID number). Well guess what? You have both of those in each <photo> element in your response from Flickr. They are stored as parameters of the <photo> element (e.g. id=”3606438858″ and owner=”29096781@N02″). Here is data on one of the photos Flickr responded with:

<photo id=”3606436456″ owner=”29096781@N02″ secret=”3409b568ff” server=”3601″ farm=”4″ title=”IMG_0547″ ispublic=”1″ isfriend=”0″ isfamily=”0″/>

Go ahead and replace the ‘photo id’ and ‘owner’ values in the URL of the sunflower picture above. You should have something like this:

http://www.flickr.com/photos/29096781@N02/3606436456/

If you click that, you will be taken to a photo that I took. However, if you put in the ‘photo id’ and ‘owner’ values of one of the photo elements in the data you requested from Flickr, then you will most likely be taken to a different photo.



