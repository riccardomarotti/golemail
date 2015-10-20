# Golemail ([Golem](https://en.wikipedia.org/wiki/Golem) + [Email](https://en.wikipedia.org/wiki/Email)) #

A pet project, that aims to remove Google Inbox from my life :) (and to use a functional language)

###Why?

Google Inbox is a very cool product, and I find that its reminders system, living inside your email, is simple and effective.
What I really like is that you can delay an email or create a reminder that will appear in you inbox at the moment you scheduled.

But... you can use it only with a Gmail account.


###So?

So I thought of a system like this...

When you receive an email that you can't manage now, you forward it to yourself, and you append a tag to the subject where you specify when it has to be scheduled.

Let's say you receive an email with subject

    "Invoice n. 42"

you can forward it to yourself, modifying the subject with something like:

    "Fdw: Invoice n. 42 - tomorrow at 5pm"

Now, the little client that I'm writing, `Golemail`, will check your inbox and

- it will recognize your forwarded email
- it will hide somewhere the forward and the original email
- tomorrow at 5pm, it will show the original email in your inbox as unread

You can also send yourself an email with subject:

    remind me to buy some apples - today at 6pm

with similar behaviour.

For security reason, there will probably be the needing of a sort of configurable tag to mark email subjects, such as

    remind me to buy some apples - today at 6pm>>>

###Progress

The project is still in its very early stage.

A basic client is implemented, and I started using it.
I plan to release the first usable version by week 43.

###Contacts
If, for some reasons, you are interested in this project, or have some ideas to make it better, or whatever, please, drop me a line

riccardo at marotti.xyz