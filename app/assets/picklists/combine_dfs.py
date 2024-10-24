import pandas as pd

# Load the four CSV files into pandas DataFrames
df1 = pd.read_csv('/Users/samsonpetrosyan/Desktop/hexoland/app/assets/picklists/2x3x3M_picklist.csv')
df2 = pd.read_csv('/Users/samsonpetrosyan/Desktop/hexoland/app/assets/picklists/16M_picklist.csv')
df3 = pd.read_csv('/Users/samsonpetrosyan/Desktop/hexoland/app/assets/picklists/19M_picklist.csv')
df4 = pd.read_csv('/Users/samsonpetrosyan/Desktop/hexoland/app/assets/picklists/25M_picklist.csv')

# Combine all DataFrames into one
combined_df = pd.concat([df1, df2, df3, df4], ignore_index=True)

# Create two picklists based on 'Source Plate Name'
picklist_new_hex_bonds = combined_df[combined_df['Source Plate Name'] == 'New Hex Bonds']
picklist_others = combined_df[combined_df['Source Plate Name'] != 'New Hex Bonds']

# Save the two picklists into new CSV files
picklist_new_hex_bonds.to_csv('picklist_new_hex_bonds.csv', index=False)
picklist_others.to_csv('picklist_others.csv', index=False)

print("Picklists have been created and saved as CSV files.")
