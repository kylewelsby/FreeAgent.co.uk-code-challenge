# Notes

Here I shall share my notes and typed thinking while working through this project.

Looking at the [Challenge Spec](./CHALLENGE.pdf) we have a few points to abide by regarding Interface, Data source, and Implementation.

Going to be honest, at this point (Dec 2018) I haven't written a RubyGem in some time, so I'm going to re-research on how we structure RubyGem's.
From memory, there's a gem called [Money](https://github.com/RubyMoney/money) which is along the lines of what we're doing here.
However, this challenge is to obtain the `ExchangeRate` on a given day from currency `A` to currency `B`.

---

We have extended the functionality of the Money gem to include HistoricalBank support.

A few patches to this Gem would offer up ideal support which can — a couple of usecase examples in the examples folder.

---

## Closing notes

Due to a personal time constraint,  I have not been able to expand out these notes to explain some decisions during this project.

This project has been a fun experiment and worked rather well.

The beautiful part is writing the bank interactors, that inherit from HistoricalBank.  This inheritance allows switching the dataset out easily with anything.

The dependency of the Money gem logic can be extracted out into its library is required.

I would be very tempted to extract the Money extensions into a new project and ship it as a production project.

_watch this space_
