# swedbank2ynab

This project scrapes your Swedbank account and outputs the transactions in CSV format that works in YNAB (http://www.youneedabudget.com/). 

## Requirements

* You need to have ruby installed
* The ruby gem mechanize

## How to run

Configure categories.yml to match your categories in YNAB or leave the file empty if you do not want the categories.

Example usage:

	$ ruby swedbank2ynab.rb <your-ssn> <your-pin> <your-account-name> > swedbank2ynab-`date "+%Y%m%d-%H%M"`.csv

your-ssn is the same you use when logging in to swedbank
your-pin is your "peronlig kod"
your-account-name is the name of your account as shown on the first page. I.e "Transaktionskonto"

