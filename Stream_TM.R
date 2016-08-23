#setworking directory
#setwd("C:/Users/AMULGASPAR/Desktop/VijayAnnaProject/DataMining")

#Install active packages
install.packages("streamR")
install.packages("RCurl")
install.packages("RJSONIO")
install.packages("ROAuth")
install.packages("openxlsx")

library(streamR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(openxlsx)

#Part-1 Declare Twitter api credientials
library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

consumerKey <- "Y54KsKJvK9GIbY16cMQJ3tVgp"
consumerSecret <- "i5CQOeP93EfMjzsoUKkMnbP0yNxUwfrKQ8ILlacaA8otElYRr8"

my_oauth <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

### Stop Here!!!!!!! ###

# Copy the pin into R Console


# PART 2: Save the my_oauth data to an .Rdata file
save(my_oauth, file = "my_oauth.Rdata")

library(streamR)
load("my_oauth.Rdata")
filterStream(file.name = "tweets.xlsx", # Save tweets in a xlsx file
             track = c("#india"), # Collect tweets
             language = "en", #Only english Tweets
             timeout = 300, # Keep connection alive for 300 seconds
             oauth = my_oauth) # Use my_oauth file as the OAuth credentials

tweets.df <- parseTweets("tweets.xlsx", simplify = FALSE) 

#NLP (Text mining)
require(slam)
require(XML)
require(tm)
require(RWeka)
require(tau)
require(tm.plugin.webmining)
require(wordcloud)
require(RColorBrewer)

t <- as.character(tweets.df$text)


#data cleansing
ap.corpus <- Corpus(VectorSource(t))
ap.corpus <- tm_map(ap.corpus, PlainTextDocument)
ap.corpus <- tm_map(ap.corpus, removePunctuation)
ap.corpus <- tm_map(ap.corpus, content_transformer(tolower))

#remove URL from the text
removeURL <- function(x) gsub("http[[:alnum:][:punct:]]*","",x)
ap.corpus <- tm_map(ap.corpus, content_transformer(removeURL))

ap.corpus <- tm_map(ap.corpus, removeWords, c(stopwords("english"),"rt","it","india","retweet"))

wordcloud(ap.corpus,random.order=FALSE,scale=c(3,0.5),col=rainbow(10)) 


