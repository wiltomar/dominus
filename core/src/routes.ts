/**
 * File: src/routes/index.js
 * Description: Responsible file for calls of API.
 * Date: 08/06/2020.
 * Author: José Wiltomar DUARTE.
 */

// eslint-disable-next-line node/no-unsupported-features/es-syntax
import 'dotenv/config';
import { Router } from 'express';

const router = Router();
const AddressAPI = process.env.ADDRESS_API;

var jwt = require('jsonwebtoken');

router.get(`${AddressAPI}`, (req, res) => {
  res.status(200).send({
    return: 'Ok',
    message: `Welcome to dominusERP ${process.env.API_VERSION}, your new business partner!`,
  });
});

router.post(`${AddressAPI}/login`, (req, res) => {
  if (req.body.user === 'wiltomar' && req.body.pwd === 'swodniw') {
    const id = 1;
    var token = jwt.sign({ id }, process.env.SECRET, {
      expiresIn: 300,
    });
    return res.json({ 
      return: 'Login successful',
      auth: true, 
      token: token 
    });
  }

  res.status(401).json({ message: 'Invalid login' });
});

router.post(`${AddressAPI}/logout`, function (req, res) {
  res.json({ 
    return: 'Session has been finalized',
    auth: false, 
    token: null 
  });
});

export default router;
