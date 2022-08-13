class Photo < ApplicationRecord
  belongs_to :member
  def myurl
    "/annu_img/#{image}"
  end
  def self.allmy(nbi,start)
    if nbi
      limit(12).offset((nbi.to_i - 1)* 12)
    elsif start
      limit(12).offset(start.to_i)
    end
    
  end
  def self.prevmy(nbi,start)
    if nbi
      k=(nbi.to_i - 2)* 12
    elsif start
      k=start.to_i - 12
    end
    limit(12).offset(k).length > 0 && k >= 0 ? k :nil
  end

  def self.nextmy(nbi,start)
    if nbi
      k=(nbi.to_i)* 12
    elsif start
      k=(start.to_i + 12)
    end
    limit(12).offset(k).length > 0 && k >= 0 ? k :nil
  end
def image=(file)
    if file.is_a?(String)
    self.write_attribute(:image,file)
  else

      pathfile = file.tempfile.path
    filename =file.original_filename
   
begin
  file.open

File.open(Rails.root.join('app','assets','images', file.original_filename), 'wb') do |f|
  f.write(file.read)
end
file.close
rescue
ensure
  file.close unless file.nil?

end
 `  convert "#{Rails.root}/app/assets/images/#{file.original_filename}"    -resize '128x128'  "#{Rails.root}/app/assets/images/#{file.original_filename}"`
    self.write_attribute(:image,file.original_filename)


    end
end
def image
  read_attribute(:image).to_s

end
end