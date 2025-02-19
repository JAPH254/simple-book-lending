# BookLibrary

BookLibrary is a Ruby on Rails application for managing a library system. Users can register, log in, view available books, borrow books (with a due date), and return them.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Running the Tests](#running-the-tests)
- [Additional Notes](#additional-notes)

## Prerequisites

- **Ruby** (version 3.4.1 or later)
- **Rails** (version 7.x recommended)
- **Bundler**
- **SQLite3** (or your preferred database)

## Setup

1. **Clone the Repository:**

   ```bash
   git clone <repository_url>
   cd book_library
Install Dependencies:

Install the required gems with Bundler:

   ```bash
   bundle install
   
   Run the Database Migrations:
   bundle exec rake db:migrate
    
    Run the Database Seeds:
    bundle exec rake db:seed

    Run the Application:
    rails server

    Running the Tests
   bundle exec rspec spec

   