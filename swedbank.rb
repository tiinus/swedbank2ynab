require 'rubygems'
require 'mechanize'
require './model'

# Scraper to get transactions for an account in swedbank. Login is done using SSN and PIN.
class Swedbank 

  def initialize(ssn, pin, account)
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows IE 9'
    do_login(ssn, pin)
    get_transactions(account)
  end

  def scrapeTransactions()
    result = []
    transactions = @transactionpage.search("//div[@class='sektion-innehall2']/table")[-1].search('.//tr')
    transactions.reverse.each{|raw_trans|
      data = raw_trans.search('.//td')
      if !data.empty? && data.length > 3
        amount = data[4].search('./span').first.content.strip
        amount = amount.gsub(/\s+/,"")
        amount_f = amount.tr(',','.').to_f
        date_s = data[0].search('./span').first.content.strip
        date_d = Date.strptime(date_s, '%y-%m-%d')
        desc = data[2].content.strip
        result << Transaction.new(date_d, desc, amount_f)
      end
    }

    return result
  end

  private

  def do_login(ssn, pin)
    p ssn
    authidpage = @agent.get("https://internetbank.swedbank.se/bviPrivat/privat?ns=1")
    authform = authidpage.form('form1')
    authid2page = @agent.submit(authform, authform.buttons.first)
    authform2 = authid2page.form('form1')
    authid3page = @agent.submit(authform2, authform2.buttons.first)
    authform3 = authid3page.form('dummy_form')
    login1page = @agent.submit(authform3, authform3.buttons.first)

    login1form = login1page.form('auth')
    login1form['auth:kundnummer'] = ssn
    login1form.field_with(:name => 'auth:metod_2').options[3].select
    login2page = @agent.submit(login1form, login1form.buttons.first)

    login2form = login2page.form('form')
    login2form['form:pinkod'] = pin
    redirectpage = @agent.submit(login2form, login2form.buttons.first)
    redirectform = redirectpage.form('redirectForm')
    @startpage = @agent.submit(redirectform, redirectform.buttons.first)
  end

  def get_transactions(account)
    transactionpage = @startpage.link_with(:text => account).click
    transactionpage = transactionpage.link_with(:text => 'Visa alla').click
    while (tp = transactionpage.link_with(:text => 'Hämta fler'))
      transactionpage = tp.click
    end
    @transactionpage = transactionpage
  end

end