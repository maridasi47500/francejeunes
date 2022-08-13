class Image < ApplicationRecord
  belongs_to :sousrubimage
  def myurl
    "/annu_img/#{image}"
  end
  def self.allmy(nbi,start)
    if nbi
      limit(12).offset((nbi.to_i - 1)* 12)
    elsif start
      limit(12).offset(start.to_i)
    else
      limit(12).offset(0)

    end
    
  end
  def self.prevmy(nbi,start)
    if nbi
      k=(nbi.to_i - 2)* 12
    elsif start
      k=start.to_i - 12
    end
    k && limit(12).offset(k).length > 0 && k >= 0 ? k : nil
  end

  def self.nextmy(nbi,start)
    if nbi
      k=(nbi.to_i)* 12
    elsif start
      k=(start.to_i + 12)
    end
    k && limit(12).offset(k).length > 0 && k >= 0 ? k : nil
  end
def image=(file)
    if file.is_a?(String)
    self.write_attribute(:image,file)
  else

      pathfile = file.tempfile.path
    filename =file.original_filename
    paths=[Rails.root.join('public','annu_img','mini', file.original_filename), Rails.root.join('public','annu_img', file.original_filename)]
  
begin
  file.open

File.open(paths[0], 'wb') do |f|
  f.write(file.read)
end
file.close
rescue
ensure
  file.close unless file.nil?

end
begin
  
file.open
File.open(paths[1], 'wb') do |f|
  f.write(file.read)
end
file.close
rescue
ensure
  file.close unless file.nil?

  end
 `  convert "#{Rails.root}/public/annu_img/mini/#{file.original_filename}"    -resize '128x128'  "#{Rails.root}/public/annu_img/mini/#{file.original_filename}"`
write_attribute(:image,file.original_filename)

    end
end
def image
  read_attribute(:image)

end
end