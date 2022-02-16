import React from 'react';
import Exception from '@/components/exception';

export const NotFound = () => <Exception type="404" />;

export const NotPermission = () => <Exception type="403" />;

export const ServerCrash = () => <Exception type="500" />;

