require "Libraries/SIMPLOO/dist/simploo"

class "Account" {
    public {
        __construct = function(self, initialBalance)
            self.balance = initialBalance -- Now every time we create a new Account it will have the initial balance you pass to the 'new' function.
        end;
        
        getBalance = function(self)
            return self.balance
        end;
    };
    private {
        balance = 0;
    };
}

class "SavingsAccount" extends "Account" {
    public {
        __construct = function(self, initialBalance, interestRate)
            self.Account(initialBalance) -- Call the parent class constructor.
            
            self.interest = interestRate
        end;
		
		getBalance = function(self)
			return 0
		end;
        
        getInterest = function(self)
            return self:getBalance() / 100 * self.interest
        end;
    };
    private {
        interest = 0;
    };
}

local account1 = SavingsAccount.new(512, 1.9)
local account2 = SavingsAccount.new(50, 1.9)