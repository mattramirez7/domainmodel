struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    
    var amount : Int
    var currency : String
    
    func convert(_ currName : String) -> Money {

        let usd = getUSD(current: Money(amount: self.amount, currency: self.currency))
        
        switch currName {
        case "GBP":
            return Money(amount: usd.amount / 2, currency: currName)
        case "EUR":
            return Money(amount: Int(Double(usd.amount) * 1.5), currency: currName)
        case "CAN":
            return Money(amount: Int(Double(usd.amount) * 1.25), currency: currName)
        default :
            return usd
        }
    }
    
    func add(_ value : Money) -> Money {
        var startVal = self
        if value.currency != self.currency {
            startVal = startVal.convert(value.currency)
        }
        return (Money(amount: (startVal.amount + value.amount), currency: value.currency))
    }
    
    func subtract(_ amount : Money) -> Money {
        let startVal = getUSD(current: self)
        let subtrVal = getUSD(current: amount)
        
        return Money(amount: startVal.amount - subtrVal.amount, currency: "USD").convert(amount.currency)
    }
    
    func getUSD(current : Money) -> Money {
        switch current.currency {
        case "GBP" :
            return Money(amount: (self.amount * 2), currency: "USD")
        case "EUR" :
            return Money(amount: Int(Double(self.amount) / 1.5), currency: "USD")
        case "CAN" :
            return Money(amount: Int(Double(self.amount) / 1.25), currency: "USD")
        default :
            return current
        }
    }
    
}



////////////////////////////////////
// Job
//
public class Job {
    
    var title : String
    var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours : Int) -> Int {
        switch type {
        case .Hourly(let amount):
            return Int(amount * Double(hours))
        case .Salary(let amount):
            return Int(amount)
        }
    }
    
    func raise(byAmount : Double = 0, byPercent : Double = 0) {
        if byAmount != 0 {
            switch self.type {
            case .Hourly(let amount):
                self.type = .Hourly(amount + byAmount)
            case .Salary(let amount):
                self.type = .Salary(UInt(Double(amount) + byAmount))
            }
        } else {
            switch self.type {
            case .Hourly(let amount):
                self.type = .Hourly(amount + (amount * byPercent))
            case .Salary(let amount):
                self.type = .Salary(UInt(Double(amount) + (Double(amount) * byPercent)))
            }
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    
    var firstName : String
    var lastName : String
    var age: Int
   
    var _job : Job? = nil
    var job : Job? {
        get { return _job}
        set {
            if self.age > 16 {
                _job = newValue
            } else {
                _job = nil
            }
        }
    }
    
    var _spouse : Person? = nil
    var spouse : Person? {
        get { return _spouse}
        set {
            if self.age > 18 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
     
    init(firstName : String, lastName : String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        var output = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age)"
        
        if job != nil {
            output = output + " job:\(self.job!.title)"
        }else{
            output = output + " job:nil"
        }
        
        if spouse != nil {
            output = output + " spouse:\(self.spouse!.firstName)"
        }else{
            output = output + " spouse:nil"
        }
        return output + "]"
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    
    var members : [Person] = []
    
    init(spouse1 : Person, spouse2 : Person) {
        spouse1.spouse = nil
        spouse2.spouse = nil
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    func haveChild(_ child : Person) -> Bool {
        if members[0].age >= 21 || members[1].age >= 21 {
                members.append(child)
            return true
            }
        return false
    }
    
    func householdIncome() -> Int {
        var householdIncome = 0;
        for member in members {
            if member.job != nil {
                switch member.job!.type {
                case Job.JobType.Salary(let amount):
                    householdIncome += Int(amount)
                case Job.JobType.Hourly(let amount):
                    householdIncome += Int(amount * 2000)
                }
            }
        }
        return householdIncome
    }
}

