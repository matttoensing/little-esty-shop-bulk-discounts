# Bulk Discounts

## Background and Description

This project is a solo project extension of the group project "Little Esty Shop". 

## Learning Goals
- Write migrations to create tables and relationships between tables
- Implement CRUD functionality for a resource using forms (form_tag or form_with), buttons, and links
- Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
- Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one or more attributes
- Write model tests that fully cover the data logic of the application
- Write feature tests that fully cover the functionality of the application

## Bulk Discounts
Bulk Discounts are subject to the following criteria:

- Bulk discounts should have a percentage discount as well as a quantity threshold
- Bulk discounts should belong to a Merchant
- A Bulk discount is eligible for all items that the merchant sells. Bulk discounts for one merchant should not affect items sold by another merchant
- Merchants can have multiple bulk discounts
   - If an item meets the quantity threshold for multiple bulk discounts, only the one with the greatest percentage discount should be applied
- Bulk discounts should apply on a per-item basis
   - If the quantity of an item ordered meets or exceeds the quantity threshold, then the percentage discount should apply to that item only. Other items that did not meet the quantity threshold will not be affected.
    - The quantities of items ordered cannot be added together to meet the quantity thresholds, e.g. a customer cannot order 1 of Item A and 1 of Item B to meet a quantity threshold of 2. They must order 2 or Item A and/or 2 of Item B

## Databases and ActiveRecord
- A "Discounts" Table was added to the previous schema
- Postgres
- Postico
- DB designer

<img width="1312" alt="Screen Shot 2021-08-10 at 5 24 02 PM" src="https://user-images.githubusercontent.com/80132364/128951515-befed76b-ee5c-45de-947e-ad08f37ee033.png">


## TDD
- RSpec
- Capybara
- Launchy
- Orderly
- SimpleCov
- Pry
- Should-Matchers

## System Requirements
- Rails version 5.2.5
- Ruby 2.7.2

## User Stories

```
Merchant Bulk Discounts Index

As a merchant
When I visit my merchant dashboard
Then I see a link to view all my discounts
When I click this link
Then I am taken to my bulk discounts index page
Where I see all of my bulk discounts including their
percentage discount and quantity thresholds
And each bulk discount listed includes a link to its show page
```

```
As a merchant
When I visit the discounts index page
I see a section with a header of "Upcoming Holidays"
In this section the name and date of the next 3 upcoming US holidays are listed.

Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
```

```
Merchant Bulk Discount Create

As a merchant
When I visit my bulk discounts index
Then I see a link to create a new discount
When I click this link
Then I am taken to a new page where I see a form to add a new bulk discount
When I fill in the form with valid data
Then I am redirected back to the bulk discount index
And I see my new bulk discount listed
```

```
Merchant Bulk Discount Delete

As a merchant
When I visit my bulk discounts index
Then next to each bulk discount I see a link to delete it
When I click this link
Then I am redirected back to the bulk discounts index page
And I no longer see the discount listed
```

```
Merchant Bulk Discount Show

As a merchant
When I visit my bulk discount show page
Then I see the bulk discount's quantity threshold and percentage discount
```

```
Merchant Bulk Discount Edit

As a merchant
When I visit my bulk discount show page
Then I see a link to edit the bulk discount
When I click this link
Then I am taken to a new page with a form to edit the discount
And I see that the discounts current attributes are pre-poluated in the form
When I change any/all of the information and click submit
Then I am redirected to the bulk discount's show page
And I see that the discount's attributes have been updated
```

```
Merchant Invoice Show Page: Total Revenue and Discounted Revenue

As a merchant
When I visit my merchant invoice show page
Then I see the total revenue for my merchant from this invoice (not including discounts)
And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
```

```
Merchant Invoice Show Page: Link to applied discounts

As a merchant
When I visit my merchant invoice show page
Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
```

```
Admin Invoice Show Page: Total Revenue and Discounted Revenue

As an admin
When I visit an admin invoice show page
Then I see the total revenue from this invoice (not including discounts)
And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
```
