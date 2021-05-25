import { Entity, Column, Index } from 'typeorm';
import base from '../../common/models/base';

@Entity({ schema: 'public', name: 'currency', orderBy: { id: 'DESC' } })
class currency extends base {

  @Index('currency_ukey_isocode', { unique: true })
  @Column({ length: 3, nullable: false })
  isocode: string;

  @Column({ length: 30, nullable: false })
  description: string;

  @Column({ length: 30, nullable: false })
  pluraldescription: string;

  @Column({ length: 5, nullable: false })
  symbol: string;

  @Column({ length: 30, nullable: false })
  smallestunit: string;

  @Column({ length: 30, nullable: false })
  smallestpluralunit: string;


}