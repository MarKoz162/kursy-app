User.create!(email: 'Marcin.kozdras162@interia.pl', password: 'password', password_confirmation: 'password')
user = User.new(
  email: "user@domain.com",
  password: 'password',
  password_confirmation: 'password'
)
user.skip_confirmation!
user.save
30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: User.first.id,
    short_description: Faker::Quote.robin,
    language: Faker::ProgrammingLanguage.name,
    level: 'Beginner',
    price: Faker::Number.between(from: 1000, to: 20000)
  }])
end