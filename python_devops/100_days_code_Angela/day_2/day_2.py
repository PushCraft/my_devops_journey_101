import pandas as pd
import requests
from bs4 import BeautifulSoup

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
}

url = "https://www.amazon.com/Best-Sellers-Health-Household-Sports-Nutrition-Protein/zgbs/hpc/6973704011/"
response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, "html.parser")

products = []

# Loop through Amazon Best Seller items
for item in soup.select(".zg-grid-general-faceout, .p13n-sc-unscraped-p13n-storefront-grid-item"):
    title_elem = item.select_one(".zg-listing-axis, ._cDE1C_truncate_332_")
    price_elem = item.select_one("._cDE1C_p13n-sc-price_3m33M, .a-price .a-offscreen")

    title = title_elem.text.strip() if title_elem else "N/A"
    price = price_elem.text.strip() if price_elem else "N/A"

    products.append({"Full Title": title, "Price": price})

df = pd.DataFrame(products)
df.to_csv("amazon_top_50_protein.csv", index=False)
print("Saved top items to amazon_top_50_protein.csv")