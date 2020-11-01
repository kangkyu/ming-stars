require 'csv'

class AccountsController < ApplicationController
  def create
    headers = ['account_name', 'business_email', 'business']
    filename = "business emails #{Date.today}.csv"
    Tempfile.open do |tempfile|
      CSV.open(tempfile.path, "wb", write_headers: true, headers: headers) do |csv|
        params[:names].split("\r\n").each do |account_name|
          account_name = account_name.tr(' ', '')
          uri = URI("https://www.instagram.com/#{account_name}/?__a=1")
          res = Net::HTTP.get_response(uri)
          if res.is_a?(Net::HTTPSuccess)
            body = JSON(res.body)
            business_email = body['graphql']['user']['business_email']
            is_business = body['graphql']['user']['is_business_account']
            csv << [account_name, business_email, is_business]
          else
            puts res
            puts res.body
          end
        end
      end
      send_data File.read(tempfile.path), filename: filename, type: 'text/csv'
    end
  end
end
