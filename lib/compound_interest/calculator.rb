class CompoundIntrest
  class Calculator
    attr_accessor :principal, :interest_rate, :years, :salary, :percentage
    attr_reader :inflation

    MAX = 100.to_f.freeze

    def initialize(params)
      @salary = params.fetch(:salary)
      @principal = params.fetch(:principal)
      @years = params.fetch(:years)
      @inflation = params.fetch(:inflation) / MAX
      @percentage = params.fetch(:percentage) / MAX
      @interest_rate = params.fetch(:interest_rate) / MAX
    end

    def self.perform(params)
      c = CompoundIntrest::Calculator.new(params)
      c.perform_calculations
    end

    def perform_calculations
      total = principal
      rows = []

      years.times do |year|
        total += contributions + (total * interest_rate)
        rows << [year + 1, salary.round, contributions.round, total.round]

        @salary = (@salary * inflation) + @salary
      end

      total_saved = Money.new(total.round * 100).format
      table = Terminal::Table.new(
        headings: ['Year', 'Salary', 'Contributions', 'Totals Saved'],
        rows: rows
      )

      puts table
      puts "\nAfter #{years} years, you will save #{total_saved}."
    end

    def contributions
      (salary * percentage)
    end
  end
end
