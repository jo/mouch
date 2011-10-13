Mouch
=====

With Mouch and CouchDB you can build powerful web applications
without the need of other software components.

Mouch is for people who love purism. For people who keep control over
every single byte. For people who love things speeding fast.

Mouch consist of only three files, with together 200 lines.
Your interface is GNU Make.
The makefile controls which parts of your application needs to be updated
and triggers the commands `build` and `push`.


Build Process
-------------

With `build` you compile your project files into one JSON file, called `app.json`.
This JSON document can be deployed to a server via the `push` command.

Every Mouch project has a `app.json.erb` file. This file bundles all documents.

The simplest `app.json.erb` I could imagine is:

  {
    "docs": [
      {
        "_id": "readme",
        "text": <%=h read 'README.md' %>
      }
    ]
  }

As you see this is simply CouchDBs bulk\_doc api.

The `build` script provides routines for

* read files (`read`) and render `.erb` templates
* escape text (`h`)
* map directory structure to objects (`map`)
* base64 encode content (`base64`)


Example
-------

A nice way to have each document seperated, as shown in this a little more complex example:

### `app.json.erb`

  {
    "docs": [
      <%= read 'hello-world/app.json.erb' %>
    ]
  }


### `hello-world/app.json.erb`

  {
    "_id": "_design/hello-world",
  
    "filters": <%= map 'filters' %>,
    "lists": <%= map 'lists' %>,
    "rewrites": <%= read 'rewrites.json' %>,
    "shows": <%= map 'shows' %>,
    "updates": <%= map 'updates' %>,
    "views": <%= map 'views' %>,
  
    "_attachments": {
      "favicon.ico": {
        "content_type": "image/x-icon; charset=utf-8",
        "data": <%=h base64 read 'favicon.ico' %>
      },
      "app.js": {
        "content_type": "application/javascript; charset=utf-8",
        "data": <%=h base64 read 'app/app.js.erb' %>
      },
      "app.css": {
        "content_type": "text/css; charset=utf-8",
        "data": <%=h base64 read ['../lib/style/*.css', 'style/*.css'] %>
      },
      "index.html": {
        "content_type": "text/html; charset=utf-8",
        "data": <%=h base64 read 'index.html.erb' %>
      }
    }
  }


### Example Directory Structure

Having a directory structure like this:

  .
  ├── app.json.erb
  ├── build
  ├── lib
  │   └── style
  │       └── app.css
  ├── makefile
  ├── hello-world
  │   ├── app.json.erb
  │   ├── favicon.ico
  │   ├── filters
  │   │   └── docs.js
  │   ├── index.html.erb
  │   ├── lists
  │   │   └── table.js
  │   ├── rewrites.json
  │   ├── shows
  │   │   └── doc.js
  │   ├── style
  │   │   └── app.css
  │   ├── updates
  │   │   └── doc.js
  │   └── views
  │       └── docs
  │           ├── map.js
  │           └── reduce.js
  ├── push
  └── README.md


Make
----

The `app.json` file is build with

  make


Create a database

  make setup URL=http://localhost:5984/hello-world


You can push it to the server

  make install URL=http://localhost:5984/hello-world


To build from scatch, one can do

  make all URL=http://localhost:5984/hello-world



Installation
------------

Mouch lives inside your project. You can install it as a git submodule or copy the three plain files around.

Mouch has a few prerequisites:

* make
* ruby
* ruby-json
* curl

Mouch build and push scripts are plain Ruby. No rubygems. (They are so slow)
I would love to see the ruby json requirement going away. Any help appreciated.


I would love to hear your opinions. Please get in touch with me.

(c) Johannes J. Schmidt, 2011
