const properties = require('./json/properties.json');
const users = require('./json/users.json');
const { Pool } = require('pg');

const pool = new Pool({
  user: 'VagrantAdmin',
  password: 'sevennine79',
  host: 'localhost',
  database: 'lightbnb'
});

/// Users

/**
 * Get a single user from the database given their email.
 * @param {String} email The email of the user.
 * @return {Promise<{}>} A promise to the user.
 */
const getUserWithEmail = function(email) {
  const getUserWithEmailQuery = `
  SELECT * FROM users
  WHERE email LIKE $1
  ;`;
  return pool.query(getUserWithEmailQuery, [email])
  .then(res => {
    if(res.rows) {
    return res.rows[0]
    } else {
      return null
    }
  })
  .catch(err => {
    console.log(err)
  });
}
exports.getUserWithEmail = getUserWithEmail;

/**
 * Get a single user from the database given their id.
 * @param {string} id The id of the user.
 * @return {Promise<{}>} A promise to the user.
 */
const getUserWithId = function(id) {
  const getUserWithIdQuery = `
  SELECT * FROM users
  WHERE id = $1
  ;`;
  return pool.query(getUserWithIdQuery, [id])
  .then(res => {
    if(res.rows) {
    return res.rows[0]
    } else {
      return null
    }
  })
  .catch(err => {
    console.log(err)
  });
}
exports.getUserWithId = getUserWithId;


/**
 * Add a new user to the database.
 * @param {{name: string, password: string, email: string}} user
 * @return {Promise<{}>} A promise to the user.
 */
const addUser =  function(user) {
  const userValues = [...Object.values(user)]
  const addUserQuery = `
  INSERT INTO users (name, email, password)
  VALUES ( $1, $2, $3 )
  RETURNING *
  ;`;
  return pool.query(addUserQuery, userValues)
  .then(res => {
    if(res.rows) {
    return res.rows
    } else {
      return null
    }
  })
  .catch(err => {
    console.log(err)
  });
}
exports.addUser = addUser;

/// Reservations

/**
 * Get all reservations for a single user.
 * @param {string} guest_id The id of the user.
 * @return {Promise<[{}]>} A promise to the reservations.
 */
const getAllReservations = function(guest_id, limit = 10) {
  const getAllReservationsQuery = `
  SELECT * FROM reservations
  JOIN users ON guest_id = users.id
  JOIN properties ON properties.id = property_id
  WHERE users.id = $1
  LIMIT $2
  ;`;
  return pool.query(getAllReservationsQuery, [guest_id, limit])
  .then(res => {
    if(res.rows) {
    return res.rows
    } else {
      return null
    }
  })
  .catch(err => {
    console.log(err)
  });
}
exports.getAllReservations = getAllReservations;

/// Properties

/**
 * Get all properties.
 * @param {{}} options An object containing query options.
 * @param {*} limit The number of results to return.
 * @return {Promise<[{}]>}  A promise to the properties.
 */
const getAllProperties = function(options, limit = 5) {
  const queryParams = [];
  console.log(options);
  let statement = 'WHERE';

  // 2
  let queryString = `
  SELECT properties.*, avg(property_reviews.rating) as average_rating
  FROM properties
  JOIN property_reviews ON properties.id = property_id
  `;

  if (queryParams.length != 0) {
    statement = 'AND'
  }
  
  if (options.city) {
    queryParams.push(`%${options.city}%`);
    queryString += `${statement} city LIKE $${queryParams.length}
    `;
  }

  if (queryParams.length != 0) {
    statement = 'AND'
  }

  if (options.minimum_price_per_night) {
    queryParams.push(`${options.minimum_price_per_night * 100}`);
    queryString += `${statement} cost_per_night > $${queryParams.length}
    `;
  }

  if (queryParams.length != 0) {
    statement = 'AND'
  }

  if (options.maximum_price_per_night) {
    queryParams.push(`${options.maximum_price_per_night * 100}`);
    queryString += `${statement} cost_per_night < $${queryParams.length}
    `;
  }

  if (queryParams.length != 0) {
    statement = 'AND'
  }

  if (options.owner_id) {
    queryParams.push(`${options.owner_id}`);
    queryString += `${statement} owner_id = $${queryParams.length}
    `
  }
  
  if (options.minimum_rating) {
    queryParams.push(`${options.minimum_rating}`);
    queryString += `GROUP BY properties.id
    HAVING AVG(property_reviews.rating) >= $${queryParams.length}
    `;
  } else {
    queryString += `GROUP BY properties.id
    `
  }
  
  // 4
  queryParams.push(limit);
  queryString += `
  ORDER BY cost_per_night
  LIMIT $${queryParams.length};
  `;
  
  // 5
  console.log(queryString, queryParams);

  // 6
  return pool.query(queryString, queryParams)
  .then(res => res.rows);
}
exports.getAllProperties = getAllProperties;


/**
 * Add a property to the database
 * @param {{}} property An object containing all of the property details.
 * @return {Promise<{}>} A promise to the property.
 */
const addProperty = function(property) {
  const newPropertyValues = [
    property.owner_id,
    property.title,
    property.description,
    property.thumbnail_photo_url,
    property.cover_photo_url,
    property.cost_per_night,
    property.street,
    property.city,
    property.provence,
    property.post_code,
    property.country,
    property.parking_spaces,
    property.number_of_bathrooms,
    property.number_of_bedrooms,

  ]
  const addPropertyQuery = `
  INSERT INTO properties (owner_id, title, description, thumbnail_photo_url, cover_photo_url, cost_per_night, street, city, provence, post_code, country, parking_spaces, number_of_bathrooms, number_of_bedrooms)
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
  RETURNING *
  ;`;
  console.log(newPropertyValues)
  return pool.query(addPropertyQuery, newPropertyValues)
  .then(res => {
    if(res.rows) {
    return res.rows
    } else {
      return null
    }
  })
  .catch(err => {
    console.log(err)
  });
}
exports.addProperty = addProperty;
