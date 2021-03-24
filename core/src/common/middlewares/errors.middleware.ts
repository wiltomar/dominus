import { Request, Response, NextFunction } from 'express';
import ExceptionsHttps from '../exceptionhandler/exceptions.https';

const ErrorHandler = (
  error: ExceptionsHttps,
  request: Request,
  response: Response,
  next: NextFunction,
) => {
  const status = error.statusCode || error.status || 500;

  response.status(status).send(error);
};

export default ErrorHandler;