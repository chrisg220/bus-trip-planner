FactoryGirl.define do
  factory :trip do
    name "Trip from Code Fellows to SeaTac"

    factory :bus_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N, Seattle WA"
        trip.destination_name = "Discovery Park, Seattle, WA"
      end
    end

    factory :walking_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N, Seattle WA"
        trip.destination_name = "Amazon, Terry Avenue North, Seattle, WA"
      end
    end

    factory :ferry_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N, Seattle WA"
        trip.destination_name = "Vashon Island, WA"
      end
    end

    factory :ex_king_co_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N, Seattle WA"
        trip.destination_name = "Boeing Co, Mukilteo, WA"
      end
    end

    factory :light_rail_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N, Seattle WA"
        trip.destination_name = "SeaTac, WA"
      end
    end

    factory :car_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N, Seattle WA"
        trip.destination_name = "20601 Highway 410, Bonney Lake, WA 98391, USA"
      end
    end

    factory :not_found_trip do
      after_build do |trip|
        trip.origin_name = "Houston, TX"
        trip.destination_name = "Fake End Address"
      end
    end

    factory :no_results_trip do
      after_build do |trip|
        trip.origin_name = "511 Boren Ave N"
        trip.destination_name = "Fake End Address"
      end
    end
  end
end
