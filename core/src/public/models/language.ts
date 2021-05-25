import { Column, Entity, Index } from 'typeorm';
import base from '../../common/models/base';

@Entity({ schema: 'public', name: 'language', orderBy: { id: 'DESC' } })
class language extends base {

  @Index('language_ukey_acronym', { unique: true })
  @Column({ length: 5, nullable: false })
  acronym: string;

  @Column({ length: 40, nullable: false })
  description: string;

  @Column({ length: 20, nullable: false })
  reduceddescription: string;

  @Column({ length: 10, nullable: true })
  codepage!: string;

}

export default language;