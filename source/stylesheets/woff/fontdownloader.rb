require 'open-uri'

def downLoadFile(uri)
	data = open(uri, 'User-Agent' => 'ruby'){|f| f.read} 
	
  fileName = uri.split('/').last
	file = File.new fileName, 'w+'
	file.binmode 
	file << data 
	file.flush 
	file.close
end

list = ["http://fonts.gstatic.com/s/raleway/v9/RJMlAoFXXQEzZoMSUteGWIX0hVgzZQUfRDuZrPvH3D8.woff2",
"http://fonts.gstatic.com/s/lato/v10/h3_FseZLI76g1To6meQ4zevvDin1pK8aKteLpeZ5c0A.woff2",
"http://fonts.gstatic.com/s/lato/v10/ifRS04pY1nJBsu8-cUFUS-vvDin1pK8aKteLpeZ5c0A.woff2",
"http://fonts.gstatic.com/s/lato/v10/IY9HZVvI1cMoAHxvl0w9LQLUuEpTyoUstqEm5AMlJo4.woff2",
"http://fonts.gstatic.com/s/lato/v10/22JRxvfANxSmnAhzbFH8PgLUuEpTyoUstqEm5AMlJo4.woff2",
"http://fonts.gstatic.com/s/lato/v10/8qcEw_nrk_5HEcCpYdJu8PesZW2xOQ-xsNqO47m55DA.woff2",
"http://fonts.gstatic.com/s/lato/v10/MDadn8DQ_3oT6kvnUq_2r_esZW2xOQ-xsNqO47m55DA.woff2",
"http://fonts.gstatic.com/s/lato/v10/rZPI2gHXi8zxUjnybc2ZQALUuEpTyoUstqEm5AMlJo4.woff2",
"http://fonts.gstatic.com/s/lato/v10/MgNNr5y1C_tIEuLEmicLmwLUuEpTyoUstqEm5AMlJo4.woff2"]

list.each do |url|
  downLoadFile url
end