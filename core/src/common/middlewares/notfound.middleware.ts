import { Request, Response, NextFunction } from 'express';

const ErrorNotFoundHandler = (
  request: Request,
  response: Response,
  next: NextFunction,
) => {
  const message = 'Resource not found!';

  response.status(404).json({ return: 'Not Found', message: message });
};

export default ErrorNotFoundHandler;