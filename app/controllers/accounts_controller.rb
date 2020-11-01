require 'csv'

class AccountsController < ApplicationController
  def create
    params[:names].split("\r\n").each do |account_name|
      account_name = account_name.tr(' ', '')
      uri = URI("https://www.instagram.com/#{account_name}/?__a=1")
      res = Net::HTTP.get_response(uri)
      body = JSON(res.body) if res.is_a?(Net::HTTPSuccess)

      Tempfile.open do |tempfile|
        CSV.open(tempfile.path, "wb", write_headers: true, headers: ['account_name', 'business_email', 'business']) do |csv|
          csv << [account_name, body['graphql']['user']['business_email'], body['graphql']['user']['is_business_account']]
        end
        send_data File.read(tempfile.path), filename: "business emails #{Date.today}.csv", type: 'text/csv'
      end
    end
  end
end
