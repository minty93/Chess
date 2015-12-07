class Employee

  attr_reader :salary, :name, :title

  def initialize(salary)
    # @title = title
    @salary = salary
    # @name = name
  end

  def bonus(multiplier)
    multiplier * salary
  end

end

class Manager < Employee
  attr_reader :subordinates

  def initialize(salary)
    super
    @subordinates = []
  end

  def bonus(multiplier)
    bonus  = super(multiplier)

    subordinates.each do |employee|
      bonus += employee.bonus(multiplier)
    end

    bonus
  end

end
