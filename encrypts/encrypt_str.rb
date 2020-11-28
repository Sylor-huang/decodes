require 'base64'
require "./entry_str_helper"
class EncryptStr
  include EntryStrHelper
  #加密
  def encrypt
    c = cipher.encrypt
    c.key = Digest::SHA256.digest(cipher_key)
    en_code = Base64.encode64(c.update(file_content.to_s) + c.final)
    File.open("../encrypts/encode.md", "w") do |f| 
      f.puts en_code
    end
  end
end

EncryptStr.new.encrypt