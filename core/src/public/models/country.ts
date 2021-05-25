import { Check, Column, Entity, Index } from "typeorm";
import base from "../../common/models/base";

@Entity({ schema: 'public', name: 'country', orderBy: { id: 'DESC' } })
class country extends base {

  @Column({ length: 5, nullable: true, unique: true })
  siscomexcode!: string;

  @Column({ length: 40, nullable: false })
  name: string;

  @Column({ length: 3, nullable: false })
  acronym: string;

  @Column({ length: 2, nullable: true})
  domain!: string;

  @Column({ length: 40, nullable: true })
  gentile!: string;
}

export default country;

