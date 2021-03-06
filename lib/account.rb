require 'csv'
require 'date'

module Bank
  class Account
    attr_reader :id, :balance, :date_opened

    def initialize(id = "", balance = "", date_opened = "")
      @id = id.to_i
      @balance = balance.to_f
      @date_opened = date_opened

      raise ArgumentError.new("balance must be >= 0") if @balance < 0
      if @balance < 0
        then
        puts "balance must be >= 0"
      end

    end

    def self.all
      array =[]
      CSV.open("support/accounts.csv").each do |line|
        array << self.new(line[0], line[1], DateTime.parse(line[2]))
      end
      return array
    end

    def self.find(id)
      self.all.each do |account|
        if account.id == id then return account
        end
      end
      raise ArgumentError.new("You must select a valid account")
    end

    def withdraw(amount, limit = 0)
      if amount > 0
        if (@balance - amount) >= limit
          @balance -= amount
        else
          puts "You have insufficient funds"
        end
      else
        puts "You must withraw an amount greater than $0.00 dollars"
        raise ArgumentError.new("you must withdraw an amount greater than $0.00")
      end
      return @balance
    end

    def deposit(amount)
      if amount >= 0
        @balance += amount
      else
        puts "You must deposit an amount greater than $0.00 dollars"
        raise ArgumentError.new("you must deposit an amount greater than $0.00")
      end
      return @balance
    end

    def reset_checks
      @count = 0
    end

  end
end
  #
  # start_balance = 100.0
  # withdrawal_amount = 91.0
  # account = Bank::Account.new(1337, start_balance)
  #
  # account.withdraw(withdrawal_amount)
  # puts account.balance
