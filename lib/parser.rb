require 'nokogiri'
require 'open-uri'

module Parser
  def self.avmo_pw(keyword, count = 3)
    # 限只有英數中文可過
    ans = []
    url = "https://avmo.pw/tw/search/#{keyword}"
    puts "url: #{url}"
    doc = Nokogiri::HTML(open(URI.encode(url)))

    box_set = doc.search('a.movie-box')
    return ["搜尋沒有結果，請嘗試別的關鍵字"] if box_set.empty?

    box_set.each do |a|
      av_title = a.search('.photo-frame img')[0]['title']
      av_img_link = a.search('.photo-frame img')[0]['src'].gsub(/s.jpg\z/ , 'l.jpg') # 小圖轉大圖

      av_id = a.search('.photo-info span date')[0].content
      av_created_at = a.search('.photo-info span date')[1].content

      ans << "#{av_id}\n#{av_title}\n#{av_created_at}\n#{av_img_link}"
    end
    return ans[0...3]
  end
end
