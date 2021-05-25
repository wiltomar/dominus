import { Column, Entity, JoinColumn, OneToOne } from 'typeorm';
import base from '../../common/models/base';
import country from './country';

@Entity({ schema: 'public', name: 'countryidd', orderBy: { id: 'DESC' } })
class countryidd extends base {

  @OneToOne(() => country, (country) => country.uuid)
  @JoinColumn({ name: 'countryid' })
  countryid: country;

  @Column({ length: 3, nullable: false })
  idd: string;

  @Column({ default: true })
  isactive: boolean;
}