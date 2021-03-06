require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/account'
require 'date'

describe "Wave 1" do
  describe "Account#initialize" do
    it "Takes an ID and an initial balance" do
      id = 1337
      balance = 100.0
      account = Bank::Account.new(id, balance)

      account.must_respond_to :id
      account.id.must_equal id

      account.must_respond_to :balance
      account.balance.must_equal balance
    end

    it "Raises an ArgumentError when created with a negative balance" do
      # Note: we haven't talked about procs yet. You can think
      # of them like blocks that sit by themselves.
      # This code checks that, when the proc is executed, it
      # raises an ArgumentError.
      proc {
        Bank::Account.new(1337, -100.0)
      }.must_raise ArgumentError
    end

    it "Can be created with a balance of 0" do
      # If this raises, the test will fail. No 'must's needed!
      Bank::Account.new(1337, 0)
    end
  end

  describe "Account#withdraw" do
    it "Reduces the balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      updated_balance.must_equal expected_balance
    end

    it "Outputs a warning if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      # Another proc! This test expects something to be printed
      # to the terminal, using 'must_output'. /.+/ is a regular
      # expression matching one or more characters - as long as
      # anything at all is printed out the test will pass.
      proc {
        account.withdraw(withdrawal_amount)
      }.must_output (/.+/)
    end

    it "Doesn't modify the balance if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      # Both the value returned and the balance in the account
      # must be un-modified.
      updated_balance.must_equal start_balance
      account.balance.must_equal start_balance
    end

    it "Allows the balance to go to 0" do
      account = Bank::Account.new(1337, 100.0)
      updated_balance = account.withdraw(account.balance)
      updated_balance.must_equal 0
      account.balance.must_equal 0
    end

    it "Requires a positive withdrawal amount" do
      start_balance = 100.0
      withdrawal_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.withdraw(withdrawal_amount)
      }.must_raise ArgumentError
    end
  end

  describe "Account#deposit" do
    it "Increases the balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      updated_balance.must_equal expected_balance
    end

    it "Requires a positive deposit amount" do
      start_balance = 100.0
      deposit_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.deposit(deposit_amount)
      }.must_raise ArgumentError
    end
  end
end



describe "Account.all" do
  it "Returns an array of all accounts" do
    Bank::Account.all.must_be_kind_of Array, "Must be an array"

  end
end

describe "Test that each account has the correct number of items" do
  it "Fits the template for an account" do
    Bank::Account.all.each do |account|
      account.must_be_kind_of Bank::Account, "This should be an account"
    end
  end
end

describe "Tests that the number of accounts is correct" do
it "Account.all should be same length as CSV file" do
  file_size = CSV.readlines("support/accounts.csv").size
    Bank::Account.all.length.must_equal file_size
    end
end
#
describe "Tests that ID/Balance of 1st/nth account match whats in the CSV" do
  it "Matches the opening and closing of the .csv file" do
CSV.readlines("support/accounts.csv")[0][0].to_i.must_equal Bank::Account.all[0].id.to_i,  "the first item's ids should be the same"
CSV.readlines("support/accounts.csv")[-1][0].to_i.must_equal Bank::Account.all[-1].id.to_i,  "the last items's ids should be the same"

CSV.readlines("support/accounts.csv")[0][1].to_i.must_equal Bank::Account.all[0].balance.to_i,  "the first item's balance should be the same"
CSV.readlines("support/accounts.csv")[-1][1].to_i.must_equal Bank::Account.all[-1].balance.to_i,  "the last items's balance should be the same"
end
end

  describe "Account.find" do
    it "Returns an account that exists" do
      Bank::Account.find(1217).must_be_kind_of Bank::Account, "This should be a valid account #{}"
    end

    it "Can find the first acount in the CSV" do
      Bank::Account.find(1212).must_be_kind_of Bank::Account, "This should show account #1212"
    end
end
describe "Account.find the last" do
    it "Can find the last account from the CSV" do
        Bank::Account.find(15153).must_be_kind_of Bank::Account, "This should show account #15156"
      end


    it "Raises an error for an account that doesn't exist" do
       proc {
        Bank::Account.find(5)
      }.must_raise ArgumentError
    end
  end
