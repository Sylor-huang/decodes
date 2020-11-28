require 'base64'
require "./entry_str_helper"
class DecryptStr
  include EntryStrHelper

  #解密
  def decrypt
    content = File.read("./encode.md")
    c = cipher.decrypt
    c.key = Digest::SHA256.digest(cipher_key)
    decode_content = c.update(Base64.decode64(content.to_s)) + c.final
    File.delete('../caches/code.md')
    File.open("../caches/code.md", "w") do |f| 
      f.puts decode_content
    end
  end
end

DecryptStr.new.decrypt