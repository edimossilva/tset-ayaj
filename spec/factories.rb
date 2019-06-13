FactoryBot.define do
  factory :issues, class: Issue do
    action { Issue.actions[:open] }

    trait :open do
      action { Issue.actions[:open] }
    end
    trait :closed do
      action { Issue.actions[:closed] }
    end
  end
end