require './swedbank'
require './model'

abort("Usage: swedbank2ynab.rb <ssn> <pin> <account-name>") if ARGV.length != 3

ssn = ARGV[0]
pin = ARGV[1]
account = ARGV[2]

scraper = Swedbank.new(ssn, pin, account)
transactions = scraper.scrapeTransactions()

# print csv file in YNAB format to STDOUT
puts "Date,Payee,Category,Memo,Outflow,Inflow\n"
transactions.each{|transaction|
  format = transaction.amount >= 0 ? "%s,\"%s\",\"%s\",,,%.2f\n" : "%s,\"%s\",\"%s\",,%.2f,\n"
  puts format % [transaction.date.strftime("%Y/%m/%d"), transaction.payee, transaction.category, transaction.amount.abs]
}