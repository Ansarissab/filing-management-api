# Filing management api

A Filing management api in Ruby on Rails that is responsible for parsing & inserting the given filings into database and generate json endpoints to get this data.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Installing


* Ruby version
 3.0.1

 ```
 rvm install 3.0.1
 ```
* Database
postgresql

```
brew install postgres
```


* Clone the repository


```
mkdir FDS

cd FDS

git clone https://github.com/usmanasif/fds.git

cd fds
```

* Install Gems
```
bundle install
```

* Database creation

  ```
  rails db:create
  rails db:migrate
  ```

* Populate Database with given filings using rake task
```
  rake filings:populate_filing_xml_data
```
* Copy .env.example file and add the values of ENV
 ```
  cp .env.example .env
 ```

* Run app locally on 3000 port

  ```
  rails server
  ```

   it will run the app on this url. Visit it and you can play with it
  http://localhost:3000/

### Gems and plugins
- Used Faraday gem to make an HTTP request to giving filings URL and currency converter API
- Used Ox gem to parse the XML and got the result in the hash. Save the data in the database using the rake task.
- Used active_model_serializers to serialize API response

### Workflow and functionality
- Created database with users and awards table and stored the data of filers, receivers in users tables and used Filer and Receiver model using Single Table Inheritance (STI)
- Implemented a rake task `filings:populate_filing_xml_data` to populate given filings data to database
- User a free API to convert currency  https://free.currencyconverterapi.com/
- Created two endpoints to get filings with awards and receivers data with state filter
   -  Endpoint that filters the receivers by their state
       Use `state=NY` query params to filter receivers with state. Without filter it returns all receivers.
       get `api/receivers?state=NY`
       Heroku endpoint `https://fdsapi.herokuapp.com/api/receivers?state=NY`

       ```json
[
	{
		id: 8,
		ein: "530196605",
		name: "American Red Cross National HQ",
		address: "5 Penn Plaza 16th Floor",
		city: "New York",
		state: "NY",
		zip_code: "10001"
	},
	..
 ]
```




  -   Endpoint to get all Filings with awards
      get `api/filings`
      Heroku endpoint `https://fdsapi.herokuapp.com/api/filings`



		 [
			{
				id: 1,
				ein: "200253310",
				name: "Pasadena Community Foundation",
				address: "260 S Los Robles Avenue No 119",
				city: "Pasadena",
				state: "CA",
				zip_code: "91101",
				awards: [
				{
					id: 1,
					cash_amount_usd: "$17000.0",
					cash_amount_gbp: "£12402.95",
					purpose: "General Support and/or Capital & Program",
					receiver_id: 2
				},
				...
				],
				...
			]


### Understanding
- The keys used to get data has some inconsistency like in some file, we have `AddressUS` and in some have `USAddress` key to get address related info. So use different keys combinations to get data.
- In my understanding, In each file, we have 1 filer and that is giving awards to receivers.
