# rspec-live

rspec-live is a test runner and formatter for RSpec 3+ that shows the state of your test suite
clearly and concisely in a console window.  As files in your project are updated, created, or
removed, rspec-live reruns your specs in the background and continually updates the displayed
status.

Basic code coverage analysis is used to determine which specs to re-run based on which files
have changed. Currently, specs that run code in a separate process may not get re-run as often
as necessary (this includes acceptance tests that launch a JavaScript-capable browser). To see
updated results for these specs, you may need to re-run all specs by pressing "R".

RSpec background processes are managed intelligently, so that only one RSpec process is
running at a time, and future RSpec runs won't get queued up based on outdated file statuses.

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

### Key Commands

  - **A** (all): Toggle the display of all specs (as opposed to just failing specs) in the
    detailed list at the bottom of the screen.

  - **R** (refresh): Re-run all specs.

  - **N** (next): Reorder the detailed information about failing specs shown at the bottom of
    the screen, by rotating the next spec into the top position.

  - **V** (verbosity): Change the amount of backtrace information shown about failing specs. 

  - **Q** (quit)
