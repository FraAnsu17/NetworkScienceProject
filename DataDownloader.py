from itertools import count
from selenium import webdriver
import time
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.alert import Alert 
from selenium.common.exceptions import NoAlertPresentException
import os

chrome_options = Options()
# chrome_options.add_argument("--headless")
# prefs = {"download.default_directory" : r"C:\Users\USER\OneDrive\Desktop\ProvaDataDownload\Categories\Export"}
prefs = {"download.default_directory" : r"C:\Users\USER\OneDrive\Desktop\ProvaDataDownload\Categories\Fuels"}
# prefs = {"download.default_directory" : r"C:\Users\USER\OneDrive\Desktop\ProvaDataDownload\Categories\Food"}
# prefs = {"download.default_directory" : r"C:\Users\USER\OneDrive\Desktop\ProvaDataDownload\Categories\FoodProducts"}
# prefs = {"download.default_directory" : r"C:\Users\USER\OneDrive\Desktop\ProvaDataDownload\Categories\OresMetals"}
# prefs = {"download.default_directory" : r"C:\Users\USER\OneDrive\Desktop\ProvaDataDownload\Categories\AgricMats"}         

chrome_options.add_experimental_option("prefs",prefs)
service = webdriver.ChromeService(executable_path='./Driver/chromedriver.exe')
driver = webdriver.Chrome(service = service, options=chrome_options)

'''
# Navigate to the webpage with the table
driver.get("https://www.iban.com/country-codes")

table = driver.find_element(By.XPATH, "//table[@id='myTable']")

column_index = 2

rows = table.find_elements(By.TAG_NAME, "tr")

column_data = []
for row in rows:

    columns = row.find_elements(By.TAG_NAME, "td")
    if 0 <= column_index < len(columns):
        column_data.append(columns[column_index].text)

countries_idx = column_data

print(countries_idx)

'''

countries_idx = ['AFG', 'ALB', 'DZA', 'ASM', 'AND', 'AGO', 'AIA', 'ATA', 'ATG', 'ARG', 'ARM', 'ABW', 'AUS', 'AUT', 'AZE', 'BHS', 'BHR', 'BGD', 'BRB', 'BLR', 'BEL', 'BLZ', 'BEN', 
                'BMU', 'BTN', 'BOL', 'BES', 'BIH', 'BWA', 'BVT', 'BRA', 'IOT', 'BRN', 'BGR', 'BFA', 'BDI', 'CPV', 'KHM', 'CMR', 'CAN', 'CYM', 'CAF', 'TCD', 'CHL', 'CHN', 'CXR', 'CCK', 'COL', 'COM', 'COD', 'COG', 'COK', 'CRI', 'HRV', 'CUB', 'CUW', 'CYP', 'CZE', 'CIV', 'DNK', 'DJI', 'DMA', 'DOM', 'ECU', 'EGY', 'SLV', 'GNQ', 'ERI', 'EST', 'SWZ', 'ETH', 'FLK', 'FRO', 'FJI', 'FIN', 'FRA', 'GUF', 'PYF', 'ATF', 'GAB', 'GMB', 'GEO', 'DEU', 'GHA', 'GIB', 'GRC', 'GRL', 'GRD', 'GLP', 'GUM', 'GTM', 'GGY', 'GIN', 'GNB', 'GUY', 'HTI', 'HMD', 'VAT', 'HND', 'HKG', 'HUN', 'ISL', 'IND', 'IDN', 'IRN', 'IRQ', 'IRL', 'IMN', 'ISR', 'ITA', 'JAM', 'JPN', 'JEY', 'JOR', 'KAZ', 'KEN', 'KIR', 'PRK', 'KOR', 'KWT', 'KGZ', 'LAO', 'LVA', 'LBN', 'LSO', 'LBR', 'LBY', 'LIE', 'LTU', 'LUX', 'MAC', 'MDG', 'MWI', 'MYS', 'MDV', 'MLI', 'MLT', 'MHL', 'MTQ', 'MRT', 'MUS', 'MYT', 'MEX', 'FSM', 'MDA', 'MCO', 'MNG', 'MNE', 'MSR', 'MAR', 'MOZ', 'MMR', 'NAM', 'NRU', 'NPL', 'NLD', 'NCL', 'NZL', 'NIC', 'NER', 'NGA', 'NIU', 'NFK', 'MNP', 'NOR', 'OMN', 'PAK', 'PLW', 'PSE', 'PAN', 'PNG', 'PRY', 'PER', 'PHL', 'PCN', 'POL', 'PRT', 'PRI', 'QAT', 'MKD', 'ROU', 'RUS', 'RWA', 'REU', 'BLM', 
                'SHN', 'KNA', 'LCA', 'MAF', 'SPM', 'VCT', 'WSM', 'SMR', 'STP', 'SAU', 'SEN', 'SRB', 'SYC', 'SLE', 'SGP', 'SXM', 'SVK', 'SVN', 'SLB', 'SOM', 'ZAF', 'SGS', 'SSD', 'ESP', 'LKA', 'SDN', 'SUR', 'SJM', 'SWE', 'CHE', 'SYR', 'TWN', 'TJK', 'TZA', 'THA', 'TLS', 'TGO', 'TKL', 'TON', 'TTO', 'TUN', 'TUR', 'TKM', 'TCA', 'TUV', 'UGA', 'UKR', 'ARE', 'GBR', 'UMI', 'USA', 'URY', 'UZB', 'VUT', 'VEN', 'VNM', 'VGB', 'VIR', 'WLF', 'ESH', 'YEM', 'ZMB', 'ZWE', 'ALA']

years_list = list(range(2021, 2006, -1))
print(years_list)
countries_NA = []

# countries = ["ITA", "SGP", "AFG", "VUT"] #["ITA", "AFG", "SGP"]
# c = "ITA"

for i, c in enumerate(countries_idx[51:]):
    for y in years_list:
        # url = f"https://wits.worldbank.org/CountryProfile/en/Country/{c}/Year/{y}/TradeFlow/Export"
        url = f"https://wits.worldbank.org/CountryProfile/en/Country/{c}/Year/{y}/TradeFlow/Export/Partner/all/Product/27-27_Fuels"
        # url = f"https://wits.worldbank.org/CountryProfile/en/Country/{c}/Year/{y}/TradeFlow/Export/Partner/all/Product/Food"
        # url = f"https://wits.worldbank.org/CountryProfile/en/Country/{c}/Year/{y}/TradeFlow/Export/Partner/all/Product/16-24_FoodProd"
        # url = f"https://wits.worldbank.org/CountryProfile/en/Country/{c}/Year/{y}/TradeFlow/Export/Partner/all/Product/OresMtls"
        # url = f"https://wits.worldbank.org/CountryProfile/en/Country/{c}/Year/{y}/TradeFlow/Export/Partner/all/Product/AgrRaw"
        
        
        driver.get(url)
        time.sleep(0.5)
        # download_button = driver.find_element(By.ID, "DataDownload")
        overlay = WebDriverWait(driver, 10).until(EC.invisibility_of_element_located((By.CLASS_NAME, "QSIWebResponsive-creative-container-fade")))
        download_button = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.ID, "DataDownload")))
        overlay = WebDriverWait(driver, 10).until(EC.invisibility_of_element_located((By.CLASS_NAME, "QSIWebResponsive-creative-container-fade")))
        download_button.click()
        time.sleep(0.1)
        # excel_button = driver.find_element(By.XPATH, "//span[text()='Excel']")
        overlay = WebDriverWait(driver, 10).until(EC.invisibility_of_element_located((By.CLASS_NAME, "QSIWebResponsive-creative-container-fade")))
        excel_button = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, "//span[text()='Excel']")))
        overlay = WebDriverWait(driver, 10).until(EC.invisibility_of_element_located((By.CLASS_NAME, "QSIWebResponsive-creative-container-fade")))
        # download_button.click()
        excel_button = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, "//span[text()='Excel']")))
        excel_button.click()
        time.sleep(0.5)

        try:
            alert = Alert(driver)
            alert.accept()
            if y == years_list[-1]:
                countries_NA.append(c)
            continue
        except NoAlertPresentException:
            pass

        # old_file_path = "C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\Export\\WITS-Partner.xlsx"
        old_file_path = "C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\Fuels\\WITS-Partner.xlsx"
        # old_file_path = "C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\Food\\WITS-Partner.xlsx"
        # old_file_path = "C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\FoodProducts\\WITS-Partner.xlsx"
        # old_file_path = "C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\OresMetals\\WITS-Partner.xlsx"
        # old_file_path = "C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\AgricMats\\WITS-Partner.xlsx"
        if os.path.exists(old_file_path):
            # new_file_path = f"C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\Export\\{c}{y}.xlsx"
            new_file_path = f"C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\Fuels\\{c}{y}.xlsx"
            # new_file_path = f"C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\Food\\{c}{y}.xlsx"
            # new_file_path = f"C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\FoodProducts\\{c}{y}.xlsx"
            # new_file_path = f"C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\OresMetals\\{c}{y}.xlsx"
            # new_file_path = f"C:\\Users\\USER\\OneDrive\\Desktop\\ProvaDataDownload\\Categories\\AgricMats\\{c}{y}.xlsx"
            os.rename(old_file_path, new_file_path)
        break
    # if i % 10 == 0:
    print(f"{i+1}-th state ouf of {len(countries_idx)}")


print(countries_NA)


driver.close()

