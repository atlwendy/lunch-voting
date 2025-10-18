# Copilot Instructions for lunch-voting

## Project Overview
This is a Ruby on Rails application for collaborative lunch venue selection. Users initiate meetings, invite others, and vote on restaurants. The app automates reminders and final decision emails.

## Architecture & Key Components
- **app/models/**: Core business logic (User, Meeting, Restaurant, Vote, Invitation, etc.)
- **app/controllers/**: RESTful controllers for meetings, votes, users, invitations, restaurants
- **app/views/**: ERB templates for all user-facing pages and mailers
- **app/mailers/**: Handles email notifications (invitations, reminders, results)
- **config/routes.rb**: Defines main endpoints and resource routes
- **db/migrate/**: Database schema migrations
- **lib/yelp_query.rb**: External integration for restaurant data

## Workflow & Data Flow
- User creates a meeting → system sends invitations
- Invitees RSVP and vote on venues (up/down, can propose new)
- Reminders sent 48h before, voting locks 24h before lunch
- Winning venue emailed to RSVP'd invitees

## Developer Workflows
- **Setup**: `bundle install`, `rake db:migrate`, `rake db:seed`
- **Run server**: `rails server` or `bin/rails server`
- **Run tests**: `rake test` (tests in `test/`)
- **Debug**: Use Rails logger, inspect models/controllers, check `log/`

## Project-Specific Patterns
- **Voting logic**: See `app/models/vote.rb` and `app/controllers/votes_controller.rb`
- **Meeting lifecycle**: Managed in `app/models/meeting.rb` and `app/controllers/meetings_controller.rb`
- **Email flows**: Mailers in `app/mailers/`, templates in `app/views/*_mailer/`
- **External API**: Restaurant data via `lib/yelp_query.rb`, configured in `config/initializers/yelp.rb`
- **Time-based actions**: Reminders and locking via scheduled tasks (`config/schedule.rb`, `app/mailers/reminder_mailer.rb`)

## Conventions & Integration
- Use RESTful routes and controller actions
- Prefer model methods for business logic
- Use helpers for view logic (`app/helpers/`)
- Asset pipeline for JS/CSS/images (`app/assets/`)
- All times in UTC, scheduled jobs via `whenever` gem

## Examples
- To add a new voting feature, update `Vote` model and `votes_controller.rb`
- To change email content, edit mailers and their views
- To integrate a new restaurant API, add to `lib/` and configure in `config/initializers/`

---
For more details, see `README.md`, `config/routes.rb`, and relevant model/controller files.
