# rspec-live
[![Gem Version](https://badge.fury.io/rb/rspec-live.png)](http://badge.fury.io/rb/rspec-live)
[![Build Status](https://travis-ci.org/brianauton/rspec-live.png?branch=master)](https://travis-ci.org/brianauton/rspec-live)
[![Code Climate](https://codeclimate.com/github/brianauton/rspec-live.png)](https://codeclimate.com/github/brianauton/rspec-live)

rspec-live is a test runner and formatter for RSpec 3+ that shows the state of your test suite
clearly and concisely in a console window.  As files in your project are updated, created, or
removed, rspec-live reruns your tests in the background and continually updates the displayed
status.

### Requirements

* Ruby 1.8.7 or newer
* RSpec 3.0.0 or newer

### Getting Started

Add the gem to your Gemfile,

    gem 'rspec-live'

Update your bundle,

    bundle

And start it up.

    rspec-live
