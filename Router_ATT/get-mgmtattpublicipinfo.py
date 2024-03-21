import pandas as pd
from urllib import request
import ssl

url = "https://192.168.2.254/cgi-bin/broadbandstatistics.ha"
context = ssl._create_unverified_context()
response = request.urlopen(url, context=context)
html = response.read()
data_frames = pd.read_html(html)

flat_result = {}
for df in data_frames:
    for k, v in df.values.tolist():
        flat_result[k] = v
flat_result