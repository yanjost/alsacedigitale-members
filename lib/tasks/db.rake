require 'csv'
require 'date'

namespace :db do
  desc "TODO"
  task :import, [:csv_file] => :environment do |t, args|
    CSV.foreach(args.csv_file, col_sep: ";") do |user| #change col_sep to ',' ?
      #fields: Fonction        Nom        Prénom        Date de naissance        Lieu de naissance        Adresse complète         E-mail        Profession        Tél Perso/Pro        Date adhésion        Validité adhésion        Règlement cotisation
      address, country  = user[5].split(",")
      zip = / \d{5}/.match(address)
      street, city = address.split(zip)
      personal_phone, professional_phone = user[8].split("\n")
      user = User.create(
        password: ([*('A'..'Z'),*('0'..'9')]-%w(0 O)).sample(10).join,
        role: (user[0].empty? or user[0].downcase == "adhérent") ? "Member" : user[0],
        last_name: user[1],
        first_name: user[2],
        birth_date: Date.parse(user[3]), #JJ/MM/AAAA
        birth_place: user[4],
        zipcode: zip.to_i,
        street: street,
        city: city,
        email: user[6],
        job_position: user[7],
        personal_phone: personal_phone,
        professional_phone: professional_phone,
        subscription_date: Date.parse(user[8].empty? ? "05/12/2012" : user[8])
      )
      user.payment.build(date: Date.parse(user[9]), #mandatory
                         mode: {"espèces" => "Cash", "chèque" => "Bank Check"}[user[10].downcase])
      user.save!
    end
  end
end
