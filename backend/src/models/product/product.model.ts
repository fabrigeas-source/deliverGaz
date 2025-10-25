/**
 * Product Model
 * Manages product catalog for DeliverGaz application
 */

import { Schema, model, Document, Types } from 'mongoose';

export interface IProduct extends Document {
  name: string;
  description: string;
  price: number;
  category: string;
  brand?: string;
  images: string[];
  weight?: number;
  dimensions?: {
    length: number;
    width: number;
    height: number;
  };
  inStock: boolean;
  stockQuantity: number;
  sku: string;
  tags: string[];
  rating: number;
  reviewCount: number;
  status: 'active' | 'inactive' | 'discontinued';
  createdAt: Date;
  updatedAt: Date;
}

const ProductSchema = new Schema<IProduct>({
  name: {
    type: String,
    required: [true, 'Product name is required'],
    trim: true,
    minlength: [2, 'Product name must be at least 2 characters'],
    maxlength: [200, 'Product name cannot exceed 200 characters'],
    index: true
  },
  description: {
    type: String,
    required: [true, 'Product description is required'],
    trim: true,
    minlength: [10, 'Product description must be at least 10 characters'],
    maxlength: [1000, 'Product description cannot exceed 1000 characters']
  },
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: [0, 'Price must be positive'],
    set: (value: number) => Math.round(value * 100) / 100
  },
  category: {
    type: String,
    required: [true, 'Category is required'],
    trim: true,
    index: true
  },
  brand: {
    type: String,
    trim: true,
    index: true
  },
  images: {
    type: [String],
    default: [],
    validate: {
      validator: function(images: string[]) {
        return images.every(img => /^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$/i.test(img));
      },
      message: 'All images must be valid URLs'
    }
  },
  weight: {
    type: Number,
    min: [0, 'Weight must be positive']
  },
  dimensions: {
    length: { type: Number, min: 0 },
    width: { type: Number, min: 0 },
    height: { type: Number, min: 0 }
  },
  inStock: {
    type: Boolean,
    default: true,
    index: true
  },
  stockQuantity: {
    type: Number,
    default: 0,
    min: [0, 'Stock quantity cannot be negative']
  },
  sku: {
    type: String,
    required: true,
    unique: true,
    uppercase: true,
    trim: true
  },
  tags: {
    type: [String],
    default: [],
    index: true
  },
  rating: {
    type: Number,
    default: 0,
    min: [0, 'Rating cannot be negative'],
    max: [5, 'Rating cannot exceed 5']
  },
  reviewCount: {
    type: Number,
    default: 0,
    min: [0, 'Review count cannot be negative']
  },
  status: {
    type: String,
    enum: ['active', 'inactive', 'discontinued'],
    default: 'active',
    index: true
  }
} as any, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
ProductSchema.index({ name: 'text', description: 'text', tags: 'text' });
ProductSchema.index({ category: 1, status: 1 });
ProductSchema.index({ price: 1 });
ProductSchema.index({ rating: -1 });

export const Product = model<IProduct>('Product', ProductSchema);
export default Product;