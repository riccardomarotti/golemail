# Golemail ([Golem](https://en.wikipedia.org/wiki/Golem) + [Email](https://en.wikipedia.org/wiki/Email)) #

A pet project, that aims to remove Google Inbox from my life :) (and to use a functional language)

###Why?

Google Inbox is a very cool product, and I find that its reminders system, living inside your email, is simple and effective.
I really like that you can delay an email or create a reminder that will appear in you inbox at the moment you scheduled.

But... you can use it only with a Gmail account.


###How it works?

When you receive an email that you can't manage now, you forward it to yourself, and you append a tag to the subject where you specify when it has to be scheduled.

Let's say you receive an email with subject

    "Invoice n. 42"

you can forward it to yourself, modifying the subject with something like:

    "Fwd: Invoice n. 42 tomorrow at 5pm.>>>"

`golemail`, will check your inbox and

- it will recognize your forwarded email (by the tag .>>>, which you can configure)
- it will move in `golemail` folder the forward and the original email
- tomorrow at 5pm, it will show the original email in your inbox as unread

I'm *really sorry* but, since I'm italian, now this works *only in italian*, so "tomorrow at 5pm" actually is "domani alle 17".

You can also send yourself an email with subject:

    remind me to buy some apples today at 6pm.>>>

with similar behaviour.

If you want to change a reminder, you can open it with your email client from `golemail` folder. You can reply to the message, change the scheduling, send it. It will be updated accordingly.


###Progress

This (0.0.1) is the first released version.

Some important features are missing:
- english translation (now all "commands" are in italian)
- recurrent reminders (but you can use a calendar for this)
- a simple way to view your current reminders (now you have to look at golemail folder)

Anyway, all I need is implemented, so, don't expect these features to be available very soon :)


###Install

You need an always on linux machine. I use a small vps, via ssh.
To install:

- download the latest tgz
- extract it somewhere
    tar xvfz golemail-0.0.1.tgz
- a `golemail` directory will be created
- modify `config.json` located in `golemail/bin`
- you have to create a `golemail` folder in your mailbox (the next version will create it for you and the folder name will be configurable)
- now you can launch golemail!

`golemail` isn't a daemon yet, so you need a trick to allow the execution not to stop after disconnecting from the remote machine.

I use [tmux](https://tmux.github.io/): after launching golemail, I detach from session.
You can use nohup as well or whatever you prefer.


###Contacts
If, for some reasons, you are interested in this project, or have some ideas to make it better, or whatever, please, drop me a line

riccardo at marotti.xyz
