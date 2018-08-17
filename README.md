# GitSlap <small> Slap the Hell Outta Github </small>
Crunches the emails in commits to find users email addresses. Very useful if you're _researching somebody_... I made this for Github OSINT. It's really suprising what is located inside of git commits.

You need to use github API and generate keys otherwise it will shout at you.

Generate your keys, and place into creds.rb

```
@client_id = "yourid"
@client_secret = "yoursecret"
```


Usage:

```
./gitslap.rb <username>
```

Result:

```
Searching through http://api.github.com/search/users?q=pry0cc
Found 1 users...
------------------- High Priority -------------------
{"email"=>"pry0cc@protonmail.com", "name"=>"pry0cc"}
-----------------------------------------------------
```

