class ZipCodeRateAreas
  def initialize(zip_code_csv:)
    @zip_code_csv = zip_code_csv
    @zip_code_rate_areas = {}
  end

  def to_h
    @zip_code_csv.each do |zip_code_entry|
      zip_code = zip_code_entry["zipcode"]
      rate_area = zip_code_entry["rate_area"]

      unless @zip_code_rate_areas[zip_code]
        @zip_code_rate_areas[zip_code] = []
      end

      # add rate area unless we've already seen it
      unless @zip_code_rate_areas[zip_code].include?(rate_area)
        @zip_code_rate_areas[zip_code] << rate_area
      end
    end

    # remove any zip codes which have more than one rate area
    # since these are ambiguous
    @zip_code_rate_areas.select! do |zip_code, rate_areas|
      rate_areas.length == 1
    end

    # pop each value in hash so we have an actual value and not an array
    # i.e. instead of { '12345': ['1']} we get { '12345': '1' }
    # there's probably a better way to do this
    @zip_code_rate_areas.each_with_object({}) do |(key, value), new_hash|
      new_hash[key] = value.pop
    end
  end
end
